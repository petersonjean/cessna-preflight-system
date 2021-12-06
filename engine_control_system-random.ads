
private package   Engine_Control_System.Random    with Spark_Mode =>On   is
   function Random_Number return Integer with
   Post => Random_Number'Result <= 1;
end Engine_Control_System.Random;
