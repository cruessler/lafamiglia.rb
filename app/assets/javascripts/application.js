import css from '../stylesheets/application.scss';

import 'jquery-ujs';
import '../../../node_modules/bootstrap-sass/assets/javascripts/bootstrap';
import 'typeahead.js';

import React from 'react';
import ReactDom from 'react-dom';

import InteractiveMap from './interactive_map.jsx';
import PlayerSelector from './selectors/player_selector.jsx';

document.addEventListener('DOMContentLoaded', function(_) {
  document.querySelectorAll('.player-select').forEach(function(e) {
    ReactDom.render(
      <PlayerSelector
        name={e.dataset.name}
        players={JSON.parse(e.dataset.players)}
      />,
      e
    );
  });

  const map = document.getElementById('map');

  if (map) {
    let {
      dimensions,
      villas,
      currentPlayer,
      currentVilla,
      authenticityToken,
    } = map.dataset;

    ReactDom.render(
      <InteractiveMap
        dimensions={JSON.parse(dimensions)}
        villas={JSON.parse(villas)}
        currentPlayer={JSON.parse(currentPlayer)}
        currentVilla={JSON.parse(currentVilla)}
        authenticityToken={authenticityToken}
      />,
      map
    );
  }
});
