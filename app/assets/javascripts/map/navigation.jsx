import React, { Component } from 'react';

import Routes from '../routes.js';

class Navigation extends Component {
  constructor(props) {
    super(props);

    // https://en.wikipedia.org/wiki/Arrows_(Unicode_block)
    this.directions = [
      ['←', (x, y) => [x - 4, y]],
      ['↓', (x, y) => [x, y + 4]],
      ['↑', (x, y) => [x, y - 4]],
      ['→', (x, y) => [x + 4, y]],
    ];

    this.button = this.button.bind(this);
  }

  button([direction, fun]) {
    const { x, y } = this.props.center;
    const [newX, newY] = fun(x, y);

    return (
      <a
        className="btn btn-primary"
        onClick={e => this.props.onCenter(newX, newY, e)}
      >
        {direction}
      </a>
    );
  }

  render() {
    return <div className="navigation">{this.directions.map(this.button)}</div>;
  }
}

export default Navigation;
