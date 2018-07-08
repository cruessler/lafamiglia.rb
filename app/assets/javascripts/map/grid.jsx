import React, { Component } from 'react';

class Grid extends Component {
  constructor(props) {
    super(props);
  }

  range(from, to) {
    return Array.from(new Array(to - from + 1), (_, i) => i + from);
  }

  header() {
    return (
      <div className="page-header">
        <h1>Map</h1>
      </div>
    );
  }

  xAxis() {
    let { min_x, max_x } = this.props.dimensions;

    const range = this.range(min_x, max_x);

    return (
      <div className="row">
        {range.map(x => (
          <div key={x} className="x-axis-label">
            {x}
          </div>
        ))}
      </div>
    );
  }

  display(v) {
    return `${v.name} ${v.x}|${v.y}`;
  }

  villa(x, y) {
    const v = this.props.villas.find(v => v.x == x && v.y == y);

    if (v) {
      const classes =
        v.player.id == this.props.currentPlayer.id ? 'villa' : 'villa foreign';

      return (
        <div
          key={x}
          className={classes}
          onClick={e => this.props.onSelect(v, e)}
        >
          {this.display(v)}
        </div>
      );
    } else {
      return false;
    }
  }

  cell(x, y) {
    return (
      <div key={x} className="cell">
        {this.villa(x, y)}
      </div>
    );
  }

  row(y) {
    let { min_x, max_x } = this.props.dimensions;

    const range = this.range(min_x, max_x);

    const cells = range.map(x => this.cell(x, y));

    return (
      <div key={y} className="row">
        <div className="y-axis-label">{y}</div>
        {cells}
      </div>
    );
  }

  grid() {
    let { min_y, max_y } = this.props.dimensions;

    const range = this.range(min_y, max_y);

    return <div>{range.map(y => this.row(y))}</div>;
  }

  render() {
    return (
      <div className="col-md-8">
        <div>
          {this.header()}

          <div className="container-fluid">
            <div className="row">
              <div className="map">
                {this.xAxis()}

                {this.grid()}
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

export default Grid;
