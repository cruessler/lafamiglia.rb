import css from '../stylesheets/application.scss'

import 'jquery-ujs'
import '../../../node_modules/bootstrap-sass/assets/javascripts/bootstrap'
import 'typeahead.js'
import 'handlebars/runtime'

import React from 'react';
import ReactDom from 'react-dom';

import PlayerSelector from './selectors/player_selector.jsx';

document.addEventListener('DOMContentLoaded', function(_) {
  document.querySelectorAll('.player-select').forEach(function(e) {
    ReactDom.render(
      <PlayerSelector
        name={e.dataset.name}
        players={JSON.parse(e.dataset.players)}
      />,
    e);
  });
});
