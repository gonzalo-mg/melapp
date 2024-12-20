const { numericalId } = require("../dataValidationSchemas/numericalIdSchema");
const selectApiaryById = require("../repositories/selectApiaryById");
const createHttpError = require("../utilities/createHttpError");

async function getApiaryById(req, res, next) {
  /**
  #swagger.tags = ['Apiaries']
  #swagger.description = 'Get specific apiary of current user.'

  #swagger.security = [{
    "bearerAuth": []
  }]
    
  #swagger.responses[200] = {
    description: 'Apiary recovered as object available in payload.',
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
    await numericalId.validateAsync(req.params.apiaryId);

    const [apiary] = await selectApiaryById(req.params.apiaryId, req.userEmail);

    if (!apiary) {
      createHttpError("apiaryId not found for current user.", 404);
    }

    return res.status(200).send({
      message: "Apiary recovered as object available in payload.",
      payload: apiary,
    });
  } catch (error) {
    next(error);
  }
}

module.exports = getApiaryById;
