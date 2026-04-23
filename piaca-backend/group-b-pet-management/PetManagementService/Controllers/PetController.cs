using Microsoft.AspNetCore.Mvc;
using PetManagementService.Models;
using PetManagementService.Services;

namespace PetManagementService.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PetController : ControllerBase
    {
        private readonly IPetService _petService;

        public PetController(IPetService petService)
        {
            _petService = petService;
        }

        [HttpGet("getAllPets")]
        public async Task<ActionResult<List<Pet>>> GetAllPets()
        {
            try
            {
                var pets = await _petService.GetAllPetsAsync();
                return Ok(pets);
            }
            catch
            {
                throw new Exception("An error occurred while fetching pets.");
            }

        }

        [HttpGet("getPet")]
        public async Task<ActionResult<Pet>> GetSinglePets(Guid petId)
        {
            try
            {
                var pet = await _petService.GetSinglePetAsync(petId);

                if (pet == null)
                {
                    return NotFound("Pet not found.");
                }

                return Ok(pet);
            }
            catch (ArgumentException ex)
            {
                return BadRequest(ex.Message);
            }
            catch
            {
                return StatusCode(500, "An unexpected error occurred.");
            }
        }
    }
}