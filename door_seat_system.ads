pragma SPARK_Mode (On);

with SPARK.Text_IO;use  SPARK.Text_IO;
package Door_Seat_System is
   
   --sensor list types  : 1=> Door , 2=> Pilot Seat
   type sensor_type is (door, seat);
   
   -- enum value for sensors input value
   type sensor_value  is new Integer range 0 .. 1;
   
   -- status of the cooling system
   type Status_Sensor_System_Type is (Activated, Not_Activated);
   
   -- status of the door or seat  system with value and the status 
   type Status_System_Type  is 
      record
         Value_Measured   : sensor_value;
         Status_Sensor_System : Status_Sensor_System_Type;
      end record;

   -- Status door and seat System are  global variables determining the status of door and pilot seat systems
   Status_Door_System : Status_System_Type ;
   Status_Seat_System : Status_System_Type ;
   
   --get value from door or seat sensor
   procedure Read_Sensor(T : in sensor_type) with
     Global => (In_Out => (Standard_Output, Standard_Input,Status_Door_System,  Status_Seat_System)),
     Depends => (Standard_Output => (Standard_Output,Standard_Input,T),
                 Standard_Input  => Standard_Input, 
                 Status_Door_System   => (Status_Door_System, Standard_Input,T),
                 Status_Seat_System => ( Status_Seat_System, Standard_Input,T)
                );
   --used to run routine check on door and seat system and report to main system
   procedure Monitor_Door_Seat_System(T: in sensor_type)  with
     Global  => (In_Out => (Status_Seat_System,Status_Door_System)),
     Depends => (Status_Door_System => (Status_Door_System,T),
                 Status_Seat_System =>( Status_Seat_System,T)),
     Post    => (Is_Door_Seat_Safe(Status_Door_System,T) and Is_Door_Seat_Safe(Status_Seat_System,T));
   
   
   function Status_Door_Seat_System_To_String (Status_Door_Seat_System   : Status_Sensor_System_Type) return String;
      
   
      -- Print Status of door pr pilot seat
   procedure Print_Sensor_Status(T: in sensor_type) with
     Global => (In_Out => Standard_Output, 
	  Input  => (Status_Seat_System, Status_Door_System)),
     Depends => (Standard_Output => (Standard_Output,Status_Door_System,Status_Seat_System,T));
   
   -- Is_Door_Seat_Safe check if door and seat system are in safe position, 
   --used for verification for these sensors
   -- both conditions is important for this part of the system to be considered
   --safe as for this small plane, there should be a pilot onthe seat and door should be locked
   function Is_Door_Seat_Safe (Status : Status_System_Type; T: sensor_type) return Boolean is
     ((if (Integer(Status.Value_Measured) = 1 and T = door)
      then Status.Status_Sensor_System = Activated
      else Status.Status_Sensor_System = Not_Activated) or 
        (if (Integer(Status.Value_Measured) = 1 and T = seat)
         then Status.Status_Sensor_System = Activated
         else Status.Status_Sensor_System = Not_Activated) 
     );

   -- intialisse door and pilot seat system sensors
   procedure Init_Door_Seat with
     Global => (Output => (Standard_Output,Standard_Input,Status_Door_System,Status_Seat_System)),
     Depends => ((Standard_Output,Standard_Input,Status_Door_System,Status_Seat_System) => null),
     Post    => (Is_Door_Seat_Safe(Status_Door_System,door) and Is_Door_Seat_Safe(Status_Seat_System, seat));

end door_seat_system;
