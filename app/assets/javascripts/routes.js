class Routes {
  static switchToVilla(id) {
    return `/villas/${id}`;
  }

  static map(x, y) {
    return `/map/${x}/${y}`;
  }

  static attack(id) {
    return `/villas/${id}/movements`;
  }
}

export default Routes;
