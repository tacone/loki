export default function humanizeString(str) {
    return str
      .replace(/[A-Z]/g, (letter) => `_${letter.toLowerCase()}`)
      .replace(/[\-_]/g, " ")
      .replace(/^\s+/g, "")
      .replace(/\s+$/g, "")
      .replace(/\s+/g, " ")
      .replace(/(^\w{1})|(\s{1}\w{1})/g, (match) => match.toUpperCase());
  }
