const r = /^\d+$/;
const isInt = r.test.bind(r);

const allNumeric = (list) =>
  list.reduce((acc, cur) => {
    return acc && isInt(cur);
  }, true);

const make = (tree, path, value) =>
  [path].reduce((acc, [key, ...path]) => {
    acc[key] = acc[key] ?? {};
    acc[key] = path.length ? make(acc[key], path, value) : value;
    if (allNumeric(Object.keys(acc))) {
      acc = Object.values(acc); // convert acc to array
    }
    return acc;
  }, tree);

const undot = (obj, tree = {}) => {
  obj = obj ?? {};
  return Object.entries(obj).reduce(
    (acc, [path, value]) => make(tree, path.split("."), value),
    tree
  );
};

export default undot;
