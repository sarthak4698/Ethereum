pragma solidity 0.8.0;
contract EventOrg
{
    struct Event{
        address Organiser;
        string name ;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
    }

    mapping (uint=>Event)public events;
    mapping(address=>mapping(uint=>uint))public tickets;

uint public nextID;

function createEvent(string memory name , uint price,uint date,uint ticketCount)external
{
    require(date>block.timestamp,"you can create event for future date");
    require(ticketCount>0,"you can organize Event only if you create more than 0 tickets");

    events[nextID]=Event(msg.sender,name,date,price,ticketCount,ticketCount);
    nextID++;
}
function Buytickets(uint ID,uint quantity)external payable
{
    require(events[ID].date!=0,"Event does not Exist");
    require(block.timestamp<events[ID].date,"Event has already ended");
    Event storage _event=events[ID];
    require(msg.value==(_event.price*quantity),"Ether no enough");
    _event.ticketRemain=quantity;
    tickets[msg.sender][ID]+=quantity;
}
function tranferTicket(uint ID, uint quantity ,address to) external{
    require(events[ID].date!=0,"Event does not Exist");
    require(block.timestamp<events[ID].date,"Event has already ended");
    require(tickets[msg.sender][ID]>=quantity,"you do not have enough tickets");
    tickets[to][ID]+=quantity;
}

}
