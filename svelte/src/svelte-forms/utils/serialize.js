export function serialize(form) {
	const obj = {};
	const data = new FormData(form);
	data.forEach((value, key) => (obj[key] = value));

	return obj;
}

/**
 * creates missing form fields in the values object in case it has been
 * programmatically modified
 */
export function enforceSchema(form, values) {
	const defaults = serialize(form);
	for (const key of Object.keys(defaults)) {
		defaults[key] = '';
	}
	const newValues = { ...defaults, ...values };
	if (newValues != values) {
		return newValues;
	}
}

export function deserialize(form, values) {
	[...form.elements].forEach(function elements(input, _index) {
		// I know this "switch (true)" isn't beautiful, but it works!!!
		switch (true) {
			case !input.name:
			case input.disabled:
			case /(file|reset|submit|button)/i.test(input.type):
				break;
			case /(select-multiple)/i.test(input.type):
				[...input.options].forEach(function options(option, _selectIndex) {
					option.selected = values[input.name] && values[input.name].includes(option.value);
				});
				break;
			case /(radio)/i.test(input.type):
				input.checked = values[input.name] && values[input.name] === input.value;
				break;
			case /(checkbox)/i.test(input.type):
				input.checked = values[input.name] && values[input.name].includes(input.value);
				break;
			default:
				input.value = values[input.name] || '';
				break;
		}
	});
}
