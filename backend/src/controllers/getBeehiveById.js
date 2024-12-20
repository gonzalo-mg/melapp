const { numericalId } = require("../dataValidationSchemas/numericalIdSchema");
const selectBeehiveById = require("../repositories/selectBeehiveById");
const createHttpError = require("../utilities/createHttpError");

async function getBeehiveById(req, res, next) {
  /**
  #swagger.tags = ['Beehives']
  #swagger.description = 'Get a particualar beehive of current user.'

  #swagger.security = [{
    "bearerAuth": []
  }]
    
  #swagger.responses[200] = {
    description: 'Beehive recovered as object available in payload.',
    schema: { $ref: "#/definitions/response200" }
  }
  #swagger.responses[400] = {
    $ref: "#/schemas/validationErrorResponse"
  }
  #swagger.responses[404] = {
    $ref: "#/schemas/notFoundErrorResponse"
  }
*/
  try {
    //validar q el id es de naturaleza numerica
    await numericalId.validateAsync(req.params.beehiveId);

    const [beehive] = await selectBeehiveById(
      req.params.beehiveId,
      req.userEmail
    );

    if (!beehive) {
      createHttpError("beehiveId not found for current user.", 404);
    }

    return res.status(200).send({
      message: "Beehive recovered as object available in payload.",
      payload: beehive,
    });
  } catch (error) {
    next(error);
  }
}

module.exports = getBeehiveById;
