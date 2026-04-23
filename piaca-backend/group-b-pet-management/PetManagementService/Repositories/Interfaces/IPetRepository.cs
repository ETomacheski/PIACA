using PetManagementService.Models;

namespace PetManagementService.Repositories
{
    public interface IPetRepository
    {
        Task<List<Pet>> GetAllPetsAsync();
        Task<Pet?> GetSinglePetAsync(Guid petId);
        Task<PetDetails?> GetPetDetailsAsync(Guid petId);
    }
}