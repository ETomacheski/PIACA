using PetManagementService.Models;

namespace PetManagementService.Repositories
{
    public interface IPetRepository
    {
        Task<List<Pet>> GetAllAsync();
    }
}