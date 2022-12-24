import web3 from "./web3";
import CampaignFactory from "./build/CampaignFactory.json";

const instance = new web3.eth.Contract(
    JSON.parse(CampaignFactory.interface),
    "0x012a95701CAC62f370f4fB500bf30B91Ad75eecd"    
);

export default instance;