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
)