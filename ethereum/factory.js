import web3 from "./web3";
import CampaignFactory from "./build/CampaignFactory.json";

const instance = new web3.eth.Contract(
    JSON.parse(CampaignFactory.interface),
    "0x3aFB223B803fB4Ba6ad2161bb537e078c52913Df"    
);

export default instance;