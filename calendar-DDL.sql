
create table CalendarOwner (
    id integer,
    constraint PKOwner primary key(id)
);

create table User (
    id integer,
    FirstName varchar(20) not null,
    LastName varchar(30) not null,
    Username varchar(20) not null,
    Email varchar(30) not null,
    constraint PKUser primary key(id),
    constraint FKOwner foreign key(id) references CalendarOwner,
    constraint UUsername unique(Username)
);

create table Place (
    id integer,
    Calendar integer not null,
    Building varchar(20),
    RoomNumber char(5),
    Capacity integer,
    Amenities varchar(20),
    constraint PKPlace primary key(id),
    constraint FKOwner foreign key(id) references CalendarOwner,
    constraint FKCal foreign key(Calendar) references Calendar(id)
);

create table Calendar (
    id integer,
    CalOwner integer not null,
    CalName varchar(20) not null,
    Color varchar(10),
    constraint PKCal primary key(id),
    constraint FKOwner foreign key(CalOwner) references CalendarOwner(id)
);

create table CalEvent (
    id integer,
    Creator integer not null,
    Calendar integer not null,
    Place integer,
    Title varchar(30) not null,
    Starts datetime not null,
    Ends datetime not null,
    ReminderType char,
    ReminderTime time,
    constraint PKEvent primary key(id),
    constraint FKCreator foreign key(Creator) references User(id),
    constraint FKCalendar foreign key(Calendar) references Calendar(id),
    constraint FKPlace foreign key(Place) references Place(id),
);

create table Sharing (
    id integer,
    UserID integer not null,
    Calendar integer not null,
    Permissions char(1),
    constraint PKSharing primary key(id),
    constraint FKUser foreign key(UserID) references User(id),
    constraint FKCalendar foreign key(Calendar) references Calendar(id)
);

create table Invitation (
    id integer,
    UserID integer not null,
    EventID integer not null,
    Accepted boolean,
    constraint PKInvite primary key(id),
    constraint FKUserID foreign key(UserID) references User(id),
    constraint FKEventID foreign key(EventID) references CalEvent(id)
);