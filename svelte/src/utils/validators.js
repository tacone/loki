import emailValidator from 'email-validator';

export const isRequired = (value) => (value ? null : 'Required');

export const isNumber = (value) =>
	isNaN(value) && value !== 0 && value ? 'Must be a number' : null;

export const isEmail = (value) =>
	emailValidator.validate(value) ? null : 'Must be a valid email address';

export const composeValidators = (...validators) => (value) =>
	validators.reduce((error, validator) => error || validator(value), null);

export const mapValidators = (obj) =>
	Object.entries(obj).map(([key, callback]) => {
		return (values) => {
			const result = {};
			result[key] = callback(values[key]);
			return result;
		};
	});
