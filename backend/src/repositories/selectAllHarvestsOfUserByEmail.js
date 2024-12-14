const getPool = require("../dataBase/getPool");

async function selectAllHarvestsOfUserByEmail(email) {
  const pool = await getPool();

  const sqlCode =
    "SELECT harvests.* FROM harvests JOIN beehives ON harvests.beehiveId = beehives.beehiveId JOIN apiaries ON beehives.apiaryId = apiaries.apiaryId JOIN users ON apiaries.userEmail = users.userEmail WHERE users.userEmail = ?;";

  return await pool.query(sqlCode, [email]);
}

module.exports = selectAllHarvestsOfUserByEmail;