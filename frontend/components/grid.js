import React from "react";

function chunk(array, size) {
  const arrayChunks = [];
  let arrayCopy = [...array];
  const chunksCount = Math.ceil(arrayCopy.length / size); // Round up to the nearest integer
  for (let i = 0; i < chunksCount; i++) {
    arrayChunks.push(arrayCopy.splice(0, size));
  }
  return arrayChunks;
}

function Grid({ columns, children }) {
  return chunk(children, columns).map((row, i) => (
    <div key={i} className="row">
      {row.map((component, k) => (
        <div className="col" key={k}>
          {component}
        </div>
      ))}
    </div>
  ));
}

export default Grid;
