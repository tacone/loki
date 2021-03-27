import humanizeString from "humanize-string";
import React from "react";

function Result({ name, records }) {
  let currentKey = 0;
  const formatPercent = (value) => (Math.round(value * 100) / 100).toFixed(2);
  return (
    <>
      <h3>{humanizeString(name)}</h3>
      <table className="table results-table table-bordered">
        <thead className="thead-dark">
          <tr>
            <th scope="col">{humanizeString(name)}</th>
            <th scope="col" className="numericColumn">
              Entries
            </th>
            <th scope="col" className="numericColumn">
              %
            </th>
          </tr>
        </thead>
        <tbody>
          {records && records.length ? (
            records.map((r) => {
              return (
                <tr key={currentKey++}>
                  <td>{r.value}</td>
                  <td className="numericColumn">{r.count}</td>
                  <td className="numericColumn">{formatPercent(r.ratio)} %</td>
                </tr>
              );
            })
          ) : (
            <tr>
              <td className="text-muted text-center" colSpan="100">
                no data yet
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </>
  );
}

export default Result;
