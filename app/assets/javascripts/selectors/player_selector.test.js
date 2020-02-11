import React from 'react';
import { render } from '@testing-library/react';

import PlayerSelector from './player_selector';

describe('PlayerSelector', () => {
  test('renders', () => {
    render(<PlayerSelector players={[]} />);
  });
});
