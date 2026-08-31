import '../models/mood_result.dart';
import '../models/mood_vote_result.dart';

const MoodResult moodResultMockData = MoodResult(
  moodName: '고즈넉한 쉼표 무드',
  description:
      '오래된 골목과 조용한 공간에서 천천히 걸음을 늦추고, '
      '바쁜 일상에서 잠시 벗어나 차분하게 쉬어가는 무드예요.',
  imageUrls: [],
  memberCount: 6,
  voteResults: [
    MoodVoteResult(tag: '고즈넉한', voteCount: 3),
    MoodVoteResult(tag: '조용한', voteCount: 2),
    MoodVoteResult(tag: '골목길', voteCount: 1),
    MoodVoteResult(tag: '마당', voteCount: 1),
  ],
  reason:
      '구성원들의 선택에서 조용한 공간과 오래된 마을의 분위기가 많이 겹쳤어요. '
      '천천히 걸음을 늦추고 쉬어가고 싶은 취향이 강하게 나타났어요.',
);
