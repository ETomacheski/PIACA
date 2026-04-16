namespace PetManagementService.Models
{
    public class Occurences {
        public required string Type {get;set;}
        public required string Title {get;set;}
        public DateOnly Date {get;set;}
        public required string Description {get;set;}

        public required List<File> Attachments {get;set;}
    }
}