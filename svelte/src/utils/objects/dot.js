const isEmptyArray = (value) => Array.isArray(value) && !value.length;
const isEmptyObject = (value) => {
	if (value.constructor != Object) return false;
	for (const i in value) return false;
	return true;
};

const dot = (tree, record = {}) => {
	const make = (obj, record, path = []) =>
		Object.entries(obj).reduce((acc, [key, value]) => {
			if (value instanceof Object) {
				switch (true) {
					case isEmptyObject(value):
						acc[[...path, key].join('.')] = {};
						break;
					case isEmptyArray(value):
						acc[[...path, key].join('.')] = [];
						break;
					default:
						acc = { ...acc, ...make(value, record, [...path, key]) };
				}
			} else {
				acc[[...path, key].join('.')] = value;
			}

			return acc;
		}, record);

	return make(tree, record);
};

export default dot;
