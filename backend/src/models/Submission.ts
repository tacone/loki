import { Entity, BaseEntity, PrimaryGeneratedColumn, Column } from "typeorm";
import { ObjectType, Field, ID, Int } from "type-graphql";

@ObjectType()
@Entity({ name: "submissions" })
export class Submission extends BaseEntity {
  @Field(() => ID)
  @PrimaryGeneratedColumn()
  id: string;

  @Field(() => String)
  @Column({ type: "varchar", width: 255 })
  name: string;

  @Field(() => String)
  @Column({ type: "varchar", width: 255 })
  email_address: string;

  @Field(() => Int)
  @Column({ type: "int", default: null })
  age: number;

  @Field(() => String)
  @Column({ type: "varchar", width: 255, default: null })
  gender: string;

  @Field(() => String)
  @Column({ type: "varchar", width: 255, default: null })
  country: string;

  @Field(() => Int)
  @Column({ type: "int", default: null })
  experience_rating: number;

  @Field(() => String)
  @Column({ type: "varchar", width: 10000, default: null })
  suggested_improvements: string;

  @Field(() => String)
  @Column({ type: "varchar", width: 255, default: null })
  referrer: string;

  @Field(() => Date)
  @Column({ type: "date", default: () => "CURRENT_TIMESTAMP" })
  created_at: Date;
}
