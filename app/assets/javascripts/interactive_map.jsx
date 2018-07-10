import React, { Component } from 'react';

import AttackModal from './map/attack_modal.jsx';
import Grid from './map/grid.jsx';
import Routes from './routes.js';
import Sidebar from './map/sidebar.jsx';

class InteractiveMap extends Component {
  constructor(props) {
    super(props);

    this.state = {
      villas: this.props.villas,
      dimensions: this.props.dimensions,
      selected: null,
    };

    this.onCenter = this.onCenter.bind(this);
    this.onSelect = this.onSelect.bind(this);
  }

  onSelect(v) {
    this.setState({ selected: v });
  }

  async onCenter(x, y) {
    const href = Routes.map(x, y) + '.json';

    const response = await fetch(href);
    const { villas, dimensions } = await response.json();

    this.setState({ villas: villas, dimensions: dimensions, selected: null });
  }

  render() {
    return (
      <div className="row">
        <Grid
          currentPlayer={this.props.currentPlayer}
          dimensions={this.state.dimensions}
          villas={this.state.villas}
          onCenter={this.onCenter}
          onSelect={this.onSelect}
        />
        <Sidebar
          currentPlayer={this.props.currentPlayer}
          selected={this.state.selected}
        />
        <AttackModal
          authenticityToken={this.props.authenticityToken}
          currentVilla={this.props.currentVilla}
          target={this.state.selected}
        />
      </div>
    );
  }
}

export default InteractiveMap;
