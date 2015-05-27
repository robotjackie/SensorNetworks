#ifndef TSENSOR_H
#define TSENSOR_H

typedef nx_struct TSensorMsg 
{
    nx_uint16_t NoteID;
    nx_uint8_t Data;

} TSensorMsg_t;

enum
{
    AM_RADIO = 6
};

#endif /* TSENSOR_H */
