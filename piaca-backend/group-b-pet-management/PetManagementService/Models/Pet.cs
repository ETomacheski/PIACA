namespace PetManagementService.Models
{
    public class Pet {
        public int Status {get;set;}
        public required string Species {get;set;}
        public required string Name {get;set;}
        public required string Age {get;set;}
        public char Gender {get;set;}

        public required DateTime DateOfBirth {get;set;}
        public string? IdLink {get;set;}
        public required string Description {get;set;}

        public required string City {get;set;}
        public required string State {get;set;}

        public List<string>? Temperament {get;set;}
        public List<string>? Diseases {get;set;}
        public List<string>? Sociability {get;set;}
        public List<string>? VeterinaryCare {get;set;}

        public required PetDetails Details {get;set;}

        public required List<File> Images {get;set;}
    }
}