configuration TSensorC
{

}

implementation
{
    //TODO - General things - add here
    components TSensorC as App;

    //TODO - Temp and Light - add here

    //Radio communication
    components ActiveMessageC;
    components new AMSenderC(AM_RADIO);
    components new AMReceiverC(AM_RADIO);

    //Wiring
    App.Packet->AMSenderC;
    App.AMPacket->AMSenderC;
    App.AMSend->AMSenderC;
    App.AMControl->ActiveMessageC;
    App.Receive->AMReceiverC;

}
