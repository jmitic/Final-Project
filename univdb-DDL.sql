create table Person (
    SSN char(11),
    FirstName varchar(50) not null,
    LastName varchar(50) not null,
    City varchar(50),
    Staat char(2),
    Zip char(11),
    constraint PKPerson primary key(SSN)
);

create table Student (
    SSN char(11),
    StdMajor char(6),
    StdClass char(6),
    StdGPA decimal(3,2),
    constraint PKStudent primary key(SSN),
    constraint FKSSN foreign key(SSN) references Person(SSN)
);

create table Faculty (
    SSN char(11),
    FacHireDate date not null,
    FacDept char(6),
    FacSupervisor char(11),
    constraint PKFaculty primary key(SSN),
    constraint FKSSN foreign key(SSN) references Person(SSN),
    constraint FKSupv foreign key(FacSupervisor) references Faculty(SSN)
);

create table Course (
    CourseNo char(6),
    CourseDesc varchar(250),
    Units smallint,
    constraint PKCourse primary key(CourseNo)
);

create table Offering (
    OfferNo integer,
    FacSSN char(11),
    CourseNo char(6) not null,
    OffLocation varchar(50),
    OffDays char(6),
    OffTerm char(6),
    OffYear integer,
    OffTime time,
    constraint PKOffering primary key(OfferNo),
    constraint FKFac foreign key(FacSSN) references Faculty(SSN),
    constraint FKCourse foreign key(CourseNo) references Course
);

create table Enrollment (
    StdSSN char(11),
    OfferNo integer,
    EnrGrade decimal(3,2),
    constraint PKEnrollment primary key(StdSSN, OfferNo),
    constraint FKStudent foreign key(StdSSN) references Student(SSN),
    constraint FKOffering foreign key(OfferNo) references Offering
);

