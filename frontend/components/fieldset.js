import humanizeString from "humanize-string";
import React from "react";
import { Field } from "react-final-form";

function CheckboxFieldset(field) {
  return (
    <div className="form-check">
      {field}
      <label className="form-check-label" for="exampleCheck1">
        Check me out
      </label>
    </div>
  );
}

export { CheckboxFieldset };

function Fieldset({ name, field, label, validate, tagName }) {
  label = label || humanizeString(name);
  const id = `_survey_${name}`;

  return (
    <div className="form-group row">
      <Field name={name} validate={validate}>
        {({ input, meta }) => {
          return (
            <>
              <label htmlFor={id} className="col-sm-2 col-form-label">
                {label}
              </label>
              <div className="col-sm-10">
                {React.createElement(tagName || "input", {
                  id: id,
                  className: "form-control",
                  placeholder: label,
                  ...field.props,
                  ...input,
                })}

                {meta.error && meta.touched && (
                  <small id="emailHelp" className="form-text text-danger">
                    {meta.error}
                  </small>
                )}
              </div>
            </>
          );
        }}
      </Field>
    </div>
  );
}

export default Fieldset;
