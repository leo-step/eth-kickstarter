import React, { Component } from "react";
import { Card, Button } from "semantic-ui-react";
import Layout from "../components/Layout";
import factory from "../ethereum/factory";
import { Link } from "../routes";

class CampaignIndex extends Component {
  static async getInitialProps() {
    const campaignData = await factory.methods.getDeployedCampaigns().call();
    const campaigns = [];
    for (let i = 0; i < campaignData[0].length; i++) {
      campaigns.push({name: campaignData[0][i], address: campaignData[1][i]})
    }
    return { campaigns };
  }

  renderCampaigns() {
    const items = this.props.campaigns.map((campaign) => {
      return {
        header: campaign.name,
        meta: campaign.address,
        description: (
          <Link route={`/campaigns/${campaign.address}`}>
            <a>View Campaign</a>
          </Link>
        ),
        fluid: true,
      };
    });

    return <Card.Group items={items} />;
  }

  render() {
    return (
      <Layout>
        <div>
          <h3>Open Campaigns</h3>
          <Link route="/campaigns/new">
            <a>
              <Button
                floated="right"
                content="Create Campaign"
                icon="add circle"
                primary
              />
            </a>
          </Link>
          {this.renderCampaigns()}
        </div>
      </Layout>
    );
  }
}

export default CampaignIndex;
