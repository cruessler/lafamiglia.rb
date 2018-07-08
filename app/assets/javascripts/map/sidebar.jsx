import React, { Component } from 'react';

import Routes from '../routes.js';

class Sidebar extends Component {
  constructor(props) {
    super(props);
  }

  display(v) {
    return `${v.name} ${v.x}|${v.y}`;
  }

  selectedForeign() {
    let s = this.props.selected;

    return (
      <React.Fragment>
        <div className="villa-info">{this.display(s)}</div>

        <button
          id="attack"
          type="button"
          className="btn btn-primary"
          data-toggle="modal"
          data-target="#attackModal"
        >
          Attack
        </button>

        <a href={Routes.map(s.x, s.y)} className="btn btn-primary">
          Center on map
        </a>
      </React.Fragment>
    );
  }

  selectedOwn() {
    let s = this.props.selected;

    return (
      <React.Fragment>
        <div className="villa-info">{this.display(s)}</div>

        <a href={Routes.switchToVilla(s.id)} className="btn btn-primary">
          Switch to villa
        </a>
        <a href={Routes.map(s.x, s.y)} className="btn btn-primary">
          Center on map
        </a>
      </React.Fragment>
    );
  }

  nothingSelected() {
    return (
      <div id="map-actions">
        <div className="alert alert-info">
          Click on a villa to see the available actions.
        </div>
      </div>
    );
  }

  content() {
    let v = this.props.selected;

    if (v) {
      if (v.player.id == this.props.currentPlayer.id) {
        return this.selectedOwn();
      } else {
        return this.selectedForeign();
      }
    } else {
      return this.nothingSelected();
    }
  }

  render() {
    return (
      <div className="col-md-4 map-sidebar">
        <h2>Actions</h2>

        {this.content()}
      </div>
    );
  }
}

export default Sidebar;
