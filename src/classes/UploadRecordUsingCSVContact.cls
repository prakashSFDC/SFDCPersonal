public with sharing class UploadRecordUsingCSVContact {
    
    public Blob FileRecords{get;set;}
    String[] LineNo=new String[]{};
    List<Contact> AllContact;
    Public Pagereference UploadFile()
     {
       String FileData=FileRecords.toString();
       LineNo=FileData.split('\n');
       Allcontact=new List<Contact>();
       for(Integer i=1;i<LineNo.size();i++)
        {
          Contact con=new Contact();
          String[] ActualData=new String[]{};
          ActualData=LineNo[i].split(',');
          con.FirstName=ActualData[0];
          con.LastName=ActualData[1];
          con.Email=ActualData[2];
          con.Phone=ActualData[3];
          Allcontact.add(con);
        }
       try
       {
         insert Allcontact;
       } 
       catch(Exception e) 
        {
        
        }
       return Null;
     }
}