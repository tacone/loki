import { Arg, Field, Int, ObjectType } from "type-graphql";
import { Submission } from "../models/Submission";
import { SubmissionStat } from "../types/SubmissionStat";

@ObjectType()
export default class SubmissionStatisticsType {
  @Field((type) => [SubmissionStat])
  async age() {
    return await this.submissions_stats("age");
  }
  @Field((type) => [SubmissionStat])
  async gender() {
    return await this.submissions_stats("gender");
  }
  @Field((type) => [SubmissionStat])
  async country() {
    return await this.submissions_stats("country");
  }
  @Field((type) => [SubmissionStat])
  async experience_rating() {
    return await this.submissions_stats("experience_rating");
  }

  @Field((type) => Int)
  async total_submissions() {
    return await Submission.createQueryBuilder("submission").getCount();
  }

  async submissions_stats(field: String) {
    const total = await Submission.createQueryBuilder("submission")
      .where(`${field} is not null`)
      .getCount();

    const data = await Submission.createQueryBuilder("submission")
      .select(`${field}`, "value")
      .addSelect(`count(${field})`, "count")
      .groupBy(`submission.${field}`)
      .where(`${field} is not null`)
      .getRawMany();

    const result = data.map((record) => {
      return new SubmissionStat(
        record.value,
        record.count,
        (100 * record.count) / total
      );
    });
    return result;
  }
}
