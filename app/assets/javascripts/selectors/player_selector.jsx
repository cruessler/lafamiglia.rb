import React, { Component, useEffect, useMemo, useRef, useState } from 'react';
// https://github.com/twitter/typeahead.js
import Typeahead from 'typeahead.js';

const defaultFetchSuggestions = async (query, setSuggestions) => {
  if (query.length > 2) {
    const response = await fetch(`players/search/${query}`);

    setSuggestions(await response.json());
  }
};

const PlayerSelector = props => {
  const { fetchSuggestions = defaultFetchSuggestions } = props;

  const inputRef = useRef();

  const [isOpen, setIsOpen] = useState(false);
  const [query, setQuery] = useState('');
  const [suggestions, setSuggestions] = useState([]);
  const [players, setPlayers] = useState(props.players);

  const clickPlayer = player => {
    if (players.every(p => p.id != player.id)) {
      const newPlayers = [...players, player];

      setPlayers(newPlayers);
      setIsOpen(false);
    }
  };

  const removePlayer = id => {
    setPlayers(players.filter(p => p.id != id));
  };

  const onChange = event => {
    setQuery(event.target.value);
  };

  const item = player => (
    <div key={player.id} className="btn-group player-selected">
      <button
        className="btn btn-default btn-sm dropdown-toggle"
        type="button"
        data-toggle="dropdown"
      >
        {player.name} <span className="caret" />
      </button>
      <ul className="dropdown-menu" role="menu">
        <li>
          <a
            href="#"
            className="remove-player"
            onClick={() => removePlayer(player.id)}
          >
            Remove
          </a>
        </li>
      </ul>
    </div>
  );

  const hiddenItem = player => (
    <input
      key={player.id}
      type="hidden"
      name={`${props.name}[]`}
      value={player.id}
    />
  );

  useEffect(() => {
    const updateSuggestions = async () =>
      fetchSuggestions(query, setSuggestions);

    updateSuggestions();
  }, [query, setSuggestions]);

  const suggestion = player => (
    <a
      key={player.id}
      href="#"
      className="tt-suggestion tt-selectable"
      // By default, `onMouseDown` causes the active element to lose focus. In
      // this case, this would cause a blur in the <input> which would bubble
      // up and call the topmost <span>’s `onBlur` handler and close the menu
      // such that the `onClick` would never be called.
      onMouseDown={event => event.preventDefault()}
      onClick={() => clickPlayer(player)}
    >
      {player.name}
    </a>
  );

  const menu = isOpen ? (
    <div className="tt-menu">
      <div className="tt-dataset tt-dataset-players">
        <h4>Players</h4>
        {suggestions.map(suggestion)}
      </div>
    </div>
  ) : null;

  const input = (
    <span className="twitter-typeahead" onBlur={() => setIsOpen(false)}>
      <input
        type="text"
        className="form-control player-search tt-hint"
        readOnly=""
        autoComplete="off"
        spellCheck="false"
        tabIndex="-1"
        dir="ltr"
      />
      <input
        type="text"
        className="form-control player-search tt-input"
        placeholder="Type to search …"
        autoComplete="off"
        spellCheck="false"
        dir="auto"
        value={query}
        onFocus={() => setIsOpen(true)}
        onChange={onChange}
      />
      <pre aria-hidden="true" />
      {menu}
    </span>
  );

  return (
    <div>
      <div className="has-feedback">
        {input}
        <span className="glyphicon glyphicon-search form-control-feedback" />
        {players.map(item)}
        {players.map(hiddenItem)}
      </div>
    </div>
  );
};

export default PlayerSelector;
