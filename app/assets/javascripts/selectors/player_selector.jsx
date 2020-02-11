// https://github.com/pqx/bloodhound
import Bloodhound from 'bloodhound-js';
import React, {
  Component,
  useCallback,
  useEffect,
  useMemo,
  useRef,
  useState,
} from 'react';
// https://github.com/twitter/typeahead.js
import Typeahead from 'typeahead.js';

const PlayerSelector = props => {
  const bloodhound = useMemo(
    () =>
      new Bloodhound({
        datumTokenizer: Bloodhound.tokenizers.whitespace,
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        limit: 10,
        identify: p => p.id,
        remote: {
          url: 'players/search/%QUERY',
          wildcard: '%QUERY',
        },
      }),
    []
  );

  const datasets = useMemo(
    () => ({
      name: 'players',
      display: 'name',
      templates: {
        header: '<h4>Players</h4>',
        suggestion: p => `<a href="#">${p.name}</a>`,
      },
      source: bloodhound.ttAdapter(),
    }),
    [bloodhound]
  );

  const inputRef = useRef();

  const [players, setPlayers] = useState(props.players);

  const addPlayer = useCallback(
    (event, player) => {
      if (!players.some(p => p.id == player.id)) {
        const newPlayers = [...players, player];

        setPlayers(newPlayers);
      }
    },
    [players]
  );

  const onClick = useCallback(
    id => {
      setPlayers(players.filter(p => p.id != id));
    },
    [players]
  );

  useEffect(() => {
    $(inputRef.current).typeahead({ minLength: 0 }, datasets);
  }, []);

  useEffect(
    () => {
      $(inputRef.current).bind('typeahead:select', addPlayer);
    },
    [addPlayer]
  );

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
            onClick={() => onClick(player.id)}
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

  return (
    <div>
      <div className="has-feedback">
        <input
          ref={inputRef}
          type="text"
          className="form-control player-search"
          placeholder="Type to search …"
        />
        <span className="glyphicon glyphicon-search form-control-feedback" />
        {players.map(item)}
        {players.map(hiddenItem)}
      </div>
    </div>
  );
};

export default PlayerSelector;
