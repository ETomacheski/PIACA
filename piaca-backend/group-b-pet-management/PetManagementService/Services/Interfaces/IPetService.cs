using PetManagementService.Models;

namespace PetManagementService.Services
{
    public interface IPetService
    {
        Task<List<Pet>> GetAllPetsAsync();
        Task<Pet?> GetSinglePetAsync(Guid petId);
    }
}