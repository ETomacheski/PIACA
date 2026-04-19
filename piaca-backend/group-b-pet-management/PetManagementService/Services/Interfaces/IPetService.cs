using PetManagementService.Models;

namespace PetManagementService.Services
{
    public interface IPetService
    {
        Task<List<Pet>> GetAllAsync();
    }
}