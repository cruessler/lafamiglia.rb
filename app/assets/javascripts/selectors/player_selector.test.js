import React from 'react';
import { fireEvent, render, screen } from '@testing-library/react';

import PlayerSelector from './player_selector';

describe('PlayerSelector', () => {
  test('allows selection and removal of selection', () => {
    const mockFetchSuggestions = async (query, setSuggestions) => {
      if (query === 'player') {
        setSuggestions([{ name: 'player 1', id: 1 }]);
      }
    };

    render(
      <PlayerSelector fetchSuggestions={mockFetchSuggestions} players={[]} />
    );

    fireEvent.focus(screen.getByPlaceholderText('Type to search …'));
    fireEvent.change(screen.getByPlaceholderText('Type to search …'), {
      target: { value: 'player' },
    });

    expect(screen.queryAllByText('player 1')).toHaveLength(1);

    fireEvent.click(screen.getByText('player 1'));

    expect(screen.queryAllByText('player 1')).toHaveLength(1);

    fireEvent.click(screen.getByText('player 1'));
    fireEvent.click(screen.getByText('Remove'));

    expect(screen.queryAllByText('player 1')).toHaveLength(0);
  });
});
