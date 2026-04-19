using PetManagementService.Models;
using PetManagementService.Repositories;

namespace PetManagementService.Services
{
    public class PetService : IPetService
    {
        private readonly IPetRepository _petRepository;

        public PetService(IPetRepository petRepository)
        {
            _petRepository = petRepository;
        }

        public async Task<List<Pet>> GetAllAsync()
        {
            return await _petRepository.GetAllAsync();
        }
    }
}