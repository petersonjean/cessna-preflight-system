pragma SPARK_Mode (On);

with AS_IO_Wrapper;  use AS_IO_Wrapper; 

package body Door_Seat_System is


   
   procedure Read_Sensor(T : in sensor_type) is
      Value : Integer;
   begin
      if(T = door) then -- door sensor request
        AS_Put_Line("Please type in current Value as read by door sensor");
   elsif (T = seat) then
     AS_Put_Line("Please type in current Value as read by seat sensor");
end if;
loop
   AS_Get( Value,"Please type in integer 0 or 1");
         exit when Value in   0..1;
   AS_Put("Please type in  0 or 1 for sensor ");
   AS_Put_Line("");
end loop;
   if(T = door) then -- door sensor request
        Status_Door_System.Value_Measured := sensor_value(Value);
   elsif (T = seat) then
     Status_Seat_System.Value_Measured := sensor_value(Value);
end if;

end Read_Sensor;
   
function Status_Door_Seat_System_To_String (Status_Door_Seat_System   : Status_Sensor_System_Type) return String is
begin
   case Status_Door_Seat_System is
   when Activated =>
      return "Activated";
   when Not_Activated =>
     return " Not_Activated";  
      end case;
   end Status_Door_Seat_System_To_String;
	
   procedure Print_Sensor_Status(T: in sensor_type) is
   begin
      if(T = door) then
         AS_Put("Door is");
          AS_Put_Line(Status_Door_Seat_System_To_String(Status_Door_System.Status_Sensor_System)); 
   elsif (T = seat) then
     AS_Put("Pilot seat is");
   AS_Put_Line(Status_Door_Seat_System_To_String(Status_Seat_System.Status_Sensor_System));
end if;
       
end Print_Sensor_Status;


procedure Monitor_Door_Seat_System(T: in sensor_type)   is
begin
   if (Integer(Status_Door_System.Value_Measured) = 1 and T = door)
   then Status_Door_System.Status_Sensor_System := Activated;
   else Status_Door_System.Status_Sensor_System := Not_Activated;
   end if;
   if (Integer(Status_Seat_System.Value_Measured) = 1 and T = seat)
   then Status_Seat_System.Status_Sensor_System := Activated;
   else Status_Seat_System.Status_Sensor_System := Not_Activated;
   end if;
end Monitor_Door_Seat_System;


procedure Init_Door_Seat is
begin
   AS_Init_Standard_Input; 
   AS_Init_Standard_Output;
   Status_Door_System := (Value_Measured  => 0,
                          Status_Sensor_System => Not_Activated);
   Status_Seat_System := (Value_Measured  => 0,
                          Status_Sensor_System => Not_Activated);
end Init_Door_Seat;
   
   

end door_seat_system;
