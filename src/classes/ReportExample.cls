public class ReportExample{
   

Public ID getreportid()
{
      Report samprep = [Select Id from Report where Name='Account with Locations'];
      return samprep.Id;
}
}