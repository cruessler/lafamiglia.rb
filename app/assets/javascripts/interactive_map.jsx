import React, { Component } from 'react';

import AttackModal from './map/attack_modal.jsx';
import Grid from './map/grid.jsx';
import Sidebar from './map/sidebar.jsx';

class InteractiveMap extends Component {
  constructor(props) {
    super(props);

    this.state = { selected: null };

    this.onSelect = this.onSelect.bind(this);
  }

  onSelect(v) {
    this.setState({ selected: v });
  }

  render() {
    return (
      <div className="row">
        <Grid
          currentPlayer={this.props.currentPlayer}
          dimensions={this.props.dimensions}
          villas={this.props.villas}
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
