// https://github.com/pqx/bloodhound
import Bloodhound from "bloodhound-js";
import React, { Component} from "react";
// https://github.com/twitter/typeahead.js
import Typeahead from "typeahead.js";

class PlayerSelector extends Component {
  constructor(props) {
    super(props);

    this.bloodhound = new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.whitespace,
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      limit: 10,
      identify: p => p.id,
      remote: {
        url: "players/search/%QUERY",
        wildcard: "%QUERY"
      }
    });

    this.datasets = {
      name: "players",
      display: "name",
      templates: {
        header: "<h4>Players</h4>",
        suggestion: p => `<a href="#">${p.name}</a>`
      },
      source: this.bloodhound.ttAdapter()
    }

    // This is used for initialization of typeahead in componentDidMount.
    this.inputRef = React.createRef();

    this.state = { players: props.players };

    this.onClick = this.onClick.bind(this);
  }

  componentDidMount() {
    var typeaheadElement = this.inputRef.current;

    $(typeaheadElement).typeahead({ minLength: 0 }, this.datasets);

    $(typeaheadElement).bind("typeahead:select", (event, player) => {
      if (!this.state.players.some(p => p.id == player.id)) {
        this.state.players.push(player);

        this.setState({ players: this.state.players });
      }
    });
  }

  onClick(id) {
    this.setState({ players: this.state.players.filter((p) => p.id != id) });
  }

  item(player) {
    return(
      <div key={player.id} className="btn-group player-selected">
        <button className="btn btn-default btn-sm dropdown-toggle" type="button" data-toggle="dropdown">
          {player.name} <span className="caret"></span>
        </button>
        <ul className="dropdown-menu" role="menu">
          <li><a href="#" className="remove-player" onClick={(e) => this.onClick(player.id, e)}>Remove</a></li>
        </ul>
      </div>
    );
  }

  hiddenItem(player) {
    return(
      <input key={player.id} type="hidden" name={`${this.props.name}[]`} value={player.id}/>
    );
  }

  render() {
    return(
      <div>
        <div className="has-feedback">
          <input ref={this.inputRef} type="text" className="form-control player-search" placeholder="Type to search …" />
          <span className="glyphicon glyphicon-search form-control-feedback"></span>
          {this.state.players.map((p) => this.item(p))}
          {this.state.players.map((p) => this.hiddenItem(p))}
        </div>
      </div>
    );
  }
}

export default PlayerSelector;
