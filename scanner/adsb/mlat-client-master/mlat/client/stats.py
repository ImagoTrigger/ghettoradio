# -*- mode: python; indent-tabs-mode: nil -*-

# Part of mlat-client - an ADS-B multilateration client.
# Copyright 2015, Oliver Jowett <oliver@mutability.co.uk>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

"""
Global stats gathering.
"""

from mlat.client.util import monotonic_time, log


class Stats:
    def __init__(self):
        self.reset()

    def reset(self, now=None):
        if now is None:
            now = monotonic_time()
        self.start = now
        self.server_tx_bytes = 0
        self.server_rx_bytes = 0
        self.server_udp_bytes = 0
        self.receiver_rx_bytes = 0
        self.receiver_rx_messages = 0
        self.receiver_rx_filtered = 0
        self.mlat_positions = 0

    def log_and_reset(self):
        now = monotonic_time()
        elapsed = now - self.start

        processed = self.receiver_rx_messages - self.receiver_rx_filtered
        log('Receiver: {0:6.1f} msg/s received     {1:6.1f} msg/s processed ({2:.0f}%)',
            self.receiver_rx_messages / elapsed,
            processed / elapsed,
            0 if self.receiver_rx_messages == 0 else 100.0 * processed / self.receiver_rx_messages)
        log('Server:   {0:6.1f} kB/s from server   {1:4.1f}kB/s TCP to server  {2:6.1f}kB/s UDP to server',
            self.server_rx_bytes / elapsed / 1000.0,
            self.server_tx_bytes / elapsed / 1000.0,
            self.server_udp_bytes / elapsed / 1000.0)
        if self.mlat_positions:
            log('Results:  {0:3.1f} positions/minute',
                self.mlat_positions / elapsed * 60.0)
        self.reset(now)


global_stats = Stats()
