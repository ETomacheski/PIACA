namespace PetManagementService.Models
{
    public class PetDetails {
        public required string Breed {get;set;}
        public char Size {get;set;}
        public float Weight {get;set;}
        public required string Coat {get;set;}
        public required string Color {get;set;}
        public string? Reactivity {get;set;}
        public bool Microchip {get;set;}
    }
}