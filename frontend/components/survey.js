import { useMutation } from "@apollo/react-hooks";
import { gql } from "apollo-boost";
import Fieldset from "components/fieldset";
import emailValidator from "email-validator";
import { FORM_ERROR } from "final-form";
import { useRouter } from "next/router";
import React, { useState } from "react";
import { Form } from "react-final-form";

const validateRequired = (value) => (value ? undefined : "Required");
const validateNumber = (value) =>
  isNaN(value) && value !== 0 && value ? "Must be a number" : undefined;
const validateEmail = (value) =>
  emailValidator.validate(value) ? undefined : "Must be a valid email address";
const composeValidators = (...validators) => (value) =>
  validators.reduce((error, validator) => error || validator(value), undefined);

const Survey = ({ referrer }) => {
  const [serverError, setServerError] = useState("");
  const router = useRouter();

  const mutation = gql`
    mutation(
      $name: String!
      $email_address: String!
      $age: Int
      $gender: String
      $country: String
      $experience_rating: Int
      $suggested_improvements: String
      $referrer: String
    ) {
      create_submission(
        data: {
          name: $name
          email_address: $email_address
          age: $age
          gender: $gender
          country: $country
          experience_rating: $experience_rating
          suggested_improvements: $suggested_improvements
          referrer: $referrer
        }
      ) {
        id
      }
    }
  `;

  const [saveSubmission] = useMutation(mutation);

  const onSubmit = async (values) => {
    const requestData = {};
    for (let k in values) {
      let v = values[k];
      if (!isNaN(v)) {
        v = parseInt(v);
      }
      if (v === "") {
        v = null;
      }
      requestData[k] = v;
    }

    try {
      await saveSubmission({
        variables: { referrer, ...requestData },
      });
    } catch (e) {
      setServerError("You submission could not be saved");
      return { [FORM_ERROR]: "Login Failed" };
    }
    setServerError("");
    router.push(`/thank-you?from=${escape(referrer)}`);
  };
  return (
    <Form
      onSubmit={onSubmit}
      render={({ handleSubmit, form, submitting, pristine, values }) => (
        <form onSubmit={handleSubmit}>
          {serverError && (
            <div className="alert alert-danger">{serverError}</div>
          )}
          <Fieldset
            name="name"
            field={<input type="text" />}
            validate={validateRequired}
          ></Fieldset>

          <Fieldset
            name="email_address"
            field={<input type="text" />}
            validate={composeValidators(validateRequired, validateEmail)}
          ></Fieldset>

          <Fieldset
            name="age"
            field={<input type="text" />}
            validate={composeValidators(validateNumber)}
          ></Fieldset>

          <Fieldset
            name="gender"
            tagName="select"
            field={
              <select>
                <option>--- choose ---</option>
                <option value="male">Male</option>
                <option value="female">Female</option>
              </select>
            }
          ></Fieldset>

          <Fieldset name="country" field={<input type="text" />}></Fieldset>

          <Fieldset
            name="experience_rating"
            tagName="select"
            field={
              <select>
                <option>--- choose ---</option>
                <option value="5">5 - Great!</option>
                <option value="4">4 - Good</option>
                <option value="3">3 - Average</option>
                <option value="2">2 - Not so good</option>
                <option value="1">
                  1 - Let's pretend we don't know each other
                </option>
              </select>
            }
          ></Fieldset>

          <Fieldset
            name="suggested_improvements"
            field={<textarea />}
            tagName="textarea"
          ></Fieldset>

          <div className="buttons">
            <button
              type="submit"
              disabled={submitting}
              className="btn btn-primary"
            >
              Submit
            </button>
          </div>

          {/* <pre>{JSON.stringify(values, 0, 2)}</pre> */}
        </form>
      )}
    />
  );
};

export default Survey;
