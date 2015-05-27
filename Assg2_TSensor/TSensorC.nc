#include<TSensor.h>
#include<//TODO THE TEMPERATURE/LIGHT DETECTION FILE.H>

module TSensorC
{
    uses //General interface
    {
        //TODO INSERT STUFF HERE FROM OUR PREVIOUS ASSIGNMENT
    }

    uses //Radio functions
    {
        interface Packet;
        interface AMPacket;
        interface AMSend;
        interface SplitControl as AMControl;
        interface Receive;
    }

}

implementation
{
    bool _radioBusy = FALSE;
    message_t _packet;


    event for Boot.booted()
    {
        call Notify.enable();
        call AMControl.start();
    }
   


    event void Notify.notify(// WHEN TEMPERATURE OR LIGHT REACHES THRESHOLD, e.g. button_state_t val)
    {
	//Make sure radio is not busy
	if(_radioBusy == FALSE)
	{
	    //Creating the packet
	    TSensorMsg_t* msg = call Packet.getPayload(& _packet, sizeof(TSensorMsg_t));

	    msg->NodeID = TOS_NODE_ID; 
	    msg->Data = (uint8_t) val; //OR WHATEVER VARIABLE WAS INPUT INSIDE Notify.notify
	
	    //Sending the packet
	    if(call AMSend.send(AM_BROADCAST_ADDR, & _packet, sizeof(TSensorMsg_t)) == SUCCESS)
	    {
	        _radioBusy = TRUE;
	    }
	}
    }


    event void AMSend.sendDone(message_t *msg, error_t error)
    {
        if(msg == &_packet)
	{
	    _radioBusy = FALSE;
	}
    }

    event void AMControl.startDone(error_t error)
    {
        // Auto-generated message for when AMControl is done starting
        if(error == SUCCESS)
        {
            call //Leds.led0On(); or whichever LED is the Red one we're using
        }
        else
        { 
            call AMControl.start();
        }
    }

    event void AMControl.stopDone(error_t error)
    { 
        //  If we want a msg when the radio stops... but we don't need to do this
    }

    event message_t * Receive.receive(message_t *msg, void *payload, uint8_t len)
    {
	if(len == sizeof(TSensorMsg_t))
	{
	    TSensorMsg_t* incomingPacket = (TSensorMsg_t*) payload;
	
	    //incomingPacket->NodeId == 2;
	    unint8_t tempData = incomingPacket->Data;
	    
	    //What happens when the data is received
	    if(tempData == 1) 
	    {
		call Leds.led2On(); // OR WHICHEVER LED IS GREEN
	    }
	    if(tempData == 0) 
	    {
		call Leds.led2Off(); // OR WHICHEVER LED IS GREEN
	    }	 
	}

        return msg;
    }
}
