const selectAllApiariesOfUserByEmail = require("../repositories/selectAllApiariesOfUserByEmail");

async function getAllApiariesOfUser(req, res, next) {
  /**
  #swagger.tags = ['Apiaries']
  #swagger.description = 'Get all apiaries of current user.'

  #swagger.security = [{
    "bearerAuth": []
  }]
    
  #swagger.responses[200] = {
    description: 'Apiaries recovered as array of objects available in payload.',
    schema: { $ref: "#/definitions/response200" }
  }
*/
  try {
    const apiaries = await selectAllApiariesOfUserByEmail(req.userEmail);

    return res.status(200).send({
      message: "Apiaries recovered as array of objects available in payload.",
      payload: apiaries,
    });
  } catch (error) {
    next(error);
  }
}

module.exports = getAllApiariesOfUser;
