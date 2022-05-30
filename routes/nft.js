const express = require("express");
const { mint, transferfrom, transferOwnership, setApprovalForAll, rentnft, approve, removeTenant, isTenant, balanceOf, name, owner, ownerOf, paused, symbol, tokenURI, getApproved, isapprovedforall } = require("../controller");
const router = express.Router();

router.post("/mint", mint);
router.post("/transferFrom", transferfrom);
router.post("/transferownership",transferOwnership );
router.post("/setapprovalforall",setApprovalForAll );
router.post("/rentnft", rentnft);
router.post("/approve", approve);
router.post("/removetenant", removeTenant);
router.post("/istenant", isTenant);
router.post("/balanceof", balanceOf);
router.post("/name", name);
router.post("/owner", owner);
router.post("/ownerof", ownerOf);
router.post("/paused", paused);
router.post("/symbol", symbol);
router.post("/tokenuri", tokenURI);
router.post("/getapproved", getApproved);
router.post("/isapprovedforall", isapprovedforall);

module.exports = router;
