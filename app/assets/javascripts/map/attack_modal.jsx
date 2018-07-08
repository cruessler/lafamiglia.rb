import React, { Component } from 'react';

import Routes from '../routes.js';

class AttackModal extends Component {
  constructor(props) {
    super(props);

    // This lets us submit the form when the user clicks the "Attack" button
    // outside the form.
    this.formRef = React.createRef();

    this.onSubmit = this.onSubmit.bind(this);
  }

  onSubmit(_) {
    this.formRef.current.submit();
  }

  header() {
    return (
      <div className="modal-header">
        <button
          type="button"
          className="close"
          data-dismiss="modal"
          aria-label="Close"
        >
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 className="modal-title" id="attackModalLabel">
          Attack on{' '}
          <span id="target">
            {this.props.target ? this.props.target.name : undefined}
          </span>
        </h4>
      </div>
    );
  }

  hiddenFields() {
    return (
      <React.Fragment>
        <input name="utf8" type="hidden" value="&#x2713;" />
        <input
          type="hidden"
          name="authenticity_token"
          value={this.props.authenticityToken}
        />
        <input
          type="hidden"
          name="movement[target_id]"
          id="movement_target_id"
          value={this.props.target ? this.props.target.id : undefined}
        />
      </React.Fragment>
    );
  }

  unitFields() {
    return (
      <React.Fragment>
        <div className="form-group integer optional movement_unit_1">
          <label
            className="col-sm-3 control-label integer optional"
            htmlFor="movement_unit_1"
          >
            Beppo
          </label>
          <div className="col-sm-9">
            <input
              className="form-control numeric integer optional"
              type="number"
              step="1"
              name="movement[unit_1]"
              id="movement_unit_1"
            />
          </div>
        </div>
        <div className="form-group integer optional movement_unit_2">
          <label
            className="col-sm-3 control-label integer optional"
            htmlFor="movement_unit_2"
          >
            The convincer
          </label>
          <div className="col-sm-9">
            <input
              className="form-control numeric integer optional"
              type="number"
              step="1"
              name="movement[unit_2]"
              id="movement_unit_2"
            />
          </div>
        </div>
      </React.Fragment>
    );
  }

  form() {
    // This is based on what `simple_form_for(...)` generated server-side
    // before this component was implemented in React.
    return (
      <form
        ref={this.formRef}
        className="simple_form form-horizontal"
        noValidate="novalidate"
        id="new_movement"
        action={Routes.attack(this.props.currentVilla.id)}
        acceptCharset="UTF-8"
        method="post"
      >
        {this.hiddenFields()}
        {this.unitFields()}
      </form>
    );
  }

  body() {
    return <div className="modal-body">{this.form()}</div>;
  }

  footer() {
    return (
      <div className="modal-footer">
        <button type="button" className="btn btn-default" data-dismiss="modal">
          Close
        </button>
        <button
          type="button"
          className="btn btn-primary"
          id="attackButton"
          onClick={this.onSubmit}
        >
          Attack
        </button>
      </div>
    );
  }

  render() {
    return (
      <div
        className="modal fade"
        id="attackModal"
        tabIndex="-1"
        role="dialog"
        aria-labelledby="attackModalLabel"
        aria-hidden="true"
      >
        <div className="modal-dialog">
          <div className="modal-content">
            {this.header()}
            {this.body()}
            {this.footer()}
          </div>
        </div>
      </div>
    );
  }
}

export default AttackModal;
